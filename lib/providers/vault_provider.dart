import 'package:flutter/material.dart';
import '../core/dart_basics.dart';
import '../core/password_model.dart';

/// Experiment 5b: Vault State Management with Provider
class VaultProvider extends ChangeNotifier {
  final List<VaultItem> _items = [
    VaultItem(
      id: 'item_1',
      title: 'GitHub Developer',
      username: 'student@lab.cs506',
      password: 'k9#M!2xL8@vP0\$qZ',
      category: VaultCategory.work,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      entropy: 104.2,
      strength: PasswordStrength.strong,
      notes: 'Lab VCS authentication token',
    ),
    VaultItem(
      id: 'item_2',
      title: 'Google Cloud Platform',
      username: 'cloudadmin@domain.io',
      password: 'C7*tQ#9vL2!mP\$8xW1^z',
      category: VaultCategory.work,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      entropy: 130.8,
      strength: PasswordStrength.militaryGrade,
      notes: 'API project credentials',
    ),
  ];

  VaultCategory? _selectedCategory;
  String _searchQuery = '';

  List<VaultItem> get items {
    return _items.where((item) {
      final matchesCategory = _selectedCategory == null || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.username.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get totalCount => _items.length;
  VaultCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void addItem(VaultItem item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void filterCategory(VaultCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
