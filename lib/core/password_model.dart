import 'dart_basics.dart';

/// Vault Item Model representing a saved credential
class VaultItem {
  final String id;
  final String title;
  final String username;
  final String password;
  final VaultCategory category;
  final DateTime createdAt;
  final double entropy;
  final PasswordStrength strength;
  final String? notes;

  VaultItem({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.category,
    required this.createdAt,
    required this.entropy,
    required this.strength,
    this.notes,
  });

  VaultItem copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    VaultCategory? category,
    DateTime? createdAt,
    double? entropy,
    PasswordStrength? strength,
    String? notes,
  }) {
    return VaultItem(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      entropy: entropy ?? this.entropy,
      strength: strength ?? this.strength,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
      'entropy': entropy,
      'strength': strength.name,
      'notes': notes,
    };
  }

  factory VaultItem.fromMap(Map<String, dynamic> map) {
    return VaultItem(
      id: map['id'] as String,
      title: map['title'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      category: VaultCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => VaultCategory.personal,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      entropy: (map['entropy'] as num).toDouble(),
      strength: PasswordStrength.values.firstWhere(
        (s) => s.name == map['strength'],
        orElse: () => PasswordStrength.fair,
      ),
      notes: map['notes'] as String?,
    );
  }
}
