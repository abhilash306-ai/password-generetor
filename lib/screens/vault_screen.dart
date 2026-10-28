import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/dart_basics.dart';
import '../providers/vault_provider.dart';
import '../utils/responsive_container.dart';
import 'save_password_sheet.dart';

/// Experiment 4, 5, & 7: Vault Screen with Search, Category Filter, and CRUD Operations
class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vaultProvider = Provider.of<VaultProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Add Password',
            onPressed: () {
              SavePasswordSheet.show(
                context,
                initialPassword: '',
              );
            },
          ),
        ],
      ),
      body: ResponsiveContentContainer(
        maxWidth: 900,
        child: Column(
          children: [
            // Search Input Field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by title or username...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: vaultProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => vaultProvider.setSearchQuery(''),
                      )
                    : null,
              ),
              onChanged: (q) => vaultProvider.setSearchQuery(q),
            ),
            const SizedBox(height: 12),

            // Category Chips Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: vaultProvider.selectedCategory == null,
                    onSelected: (_) => vaultProvider.filterCategory(null),
                  ),
                  const SizedBox(width: 8),
                  ...VaultCategory.values.map((cat) {
                    final selected = vaultProvider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat.label),
                        selected: selected,
                        onSelected: (_) => vaultProvider.filterCategory(selected ? null : cat),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Vault Items List
            Expanded(
              child: vaultProvider.items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_open_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            vaultProvider.searchQuery.isNotEmpty
                                ? 'No credentials match "${vaultProvider.searchQuery}"'
                                : 'Your vault is empty.\nSave a generated password to see it here!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: vaultProvider.items.length,
                      itemBuilder: (context, index) {
                        final item = vaultProvider.items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF242C3F) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                              child: Icon(
                                _getCategoryIcon(item.category),
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  item.username,
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.category.label,
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${item.entropy.toStringAsFixed(1)} bits',
                                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, size: 20),
                                  tooltip: 'Copy password',
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: item.password));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied password for ${item.title}!'),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    vaultProvider.removeItem(item.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Removed ${item.title}'),
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add credential',
        onPressed: () {
          SavePasswordSheet.show(
            context,
            initialPassword: '',
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  IconData _getCategoryIcon(VaultCategory category) {
    switch (category) {
      case VaultCategory.social:
        return Icons.people_rounded;
      case VaultCategory.work:
        return Icons.work_rounded;
      case VaultCategory.banking:
        return Icons.account_balance_rounded;
      case VaultCategory.entertainment:
        return Icons.sports_esports_rounded;
      case VaultCategory.personal:
        return Icons.lock_rounded;
    }
  }
}
