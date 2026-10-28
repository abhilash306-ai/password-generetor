/// Experiment 1: Dart Language Basics
/// Demonstrates Dart fundamentals: Data types, Null Safety, OOP, Collections,
/// Higher-Order Functions, Enums, and Algorithmic Logic.

import 'dart:math';

// 1. Enum Definition
enum PasswordStrength { weak, fair, good, strong, military }

// 2. Abstract Class & Interface
abstract class Hashable {
  String toHash();
}

// 3. Mixin for Auditing Capabilities
mixin Auditable {
  DateTime createdAt = DateTime.now();

  void logCreation(String entityName) {
    print('[AUDIT] $entityName created at ${createdAt.toIso8601String()}');
  }
}

// 4. Object-Oriented Programming: Class with Inheritance, Mixin, and Null Safety
class GeneratedSecret with Auditable implements Hashable {
  final String value;
  final int length;
  final PasswordStrength strength;
  final double entropy;
  String? label; // Nullable field

  GeneratedSecret({
    required this.value,
    required this.length,
    required this.strength,
    required this.entropy,
    this.label,
  }) {
    logCreation('GeneratedSecret');
  }

  // Factory constructor
  factory GeneratedSecret.generate({
    int length = 16,
    bool includeUpper = true,
    bool includeLower = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
    String? label,
  }) {
    final chars = StringBuffer();
    if (includeUpper) chars.write('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (includeLower) chars.write('abcdefghijklmnopqrstuvwxyz');
    if (includeNumbers) chars.write('0123456789');
    if (includeSymbols) chars.write('!@#\$%^&*()_+-=[]{}|;:,.<>?');

    if (chars.isEmpty) {
      throw ArgumentError('At least one character set must be selected');
    }

    final random = Random.secure();
    final charList = chars.toString().split('');
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(charList[random.nextInt(charList.length)]);
    }

    final password = buffer.toString();
    final entropy = calculateEntropy(password, charList.length);
    final strength = evaluateStrength(entropy);

    return GeneratedSecret(
      value: password,
      length: length,
      strength: strength,
      entropy: entropy,
      label: label,
    );
  }

  // 5. Higher-Order function / Method implementation
  @override
  String toHash() {
    return 'HASH_${value.hashCode.toRadixString(16)}';
  }

  static double calculateEntropy(String text, int poolSize) {
    if (text.isEmpty || poolSize <= 0) return 0.0;
    return text.length * (log(poolSize) / ln2);
  }

  static PasswordStrength evaluateStrength(double entropy) {
    if (entropy < 30) return PasswordStrength.weak;
    if (entropy < 55) return PasswordStrength.fair;
    if (entropy < 80) return PasswordStrength.good;
    if (entropy < 110) return PasswordStrength.strong;
    return PasswordStrength.military;
  }

  @override
  String toString() {
    return 'Secret(val="$value", len=$length, entropy=${entropy.toStringAsFixed(1)} bits, strength=$strength, label="${label ?? 'None'}")';
  }
}

// 6. Main Function: Entry Point
void main() {
  print('========================================================');
  print('  CS506PC - UI Design (Flutter Lab) - Experiment 1      ');
  print('  Dart Language Basics & Password Generator Core Demo   ');
  print('========================================================\n');

  // Basic Types & Null Safety
  int defaultLength = 16;
  double minEntropy = 50.0;
  bool isProduction = true;
  String? optionalNotes; // Nullable
  print('1. Variable Types & Null-Safety:');
  print('   Default Length: $defaultLength');
  print('   Min Entropy: $minEntropy');
  print('   Notes (with null-coalescing): ${optionalNotes ?? "No notes provided"}');
  print('   Is Production: $isProduction\n');

  // Collections: List, Map, Set, Spread Operator, Collection-if
  print('2. Dart Collections & Collection-if:');
  final flags = ['uppercase', 'lowercase', if (isProduction) 'symbols'];
  final configMap = <String, dynamic>{
    'length': defaultLength,
    'flags': flags,
    'presets': {'PIN': 4, 'Standard': 12, 'Secure': 20, 'Max': 32},
  };
  print('   Config Map: $configMap');
  print('   Supported Presets: ${configMap['presets'].keys.toList()}\n');

  // Object-Oriented Generation
  print('3. Object-Oriented Secret Generation:');
  final secret1 = GeneratedSecret.generate(
    length: 18,
    includeUpper: true,
    includeLower: true,
    includeNumbers: true,
    includeSymbols: true,
    label: 'Primary Vault Master Key',
  );
  print('   $secret1');
  print('   Hash: ${secret1.toHash()}\n');

  // Higher-Order Functions: map, where, reduce
  print('4. Functional Programming (map & filter):');
  final lengthList = [8, 12, 16, 24, 32];
  final generatedSecrets = lengthList.map((len) {
    return GeneratedSecret.generate(length: len, label: 'Profile-$len');
  }).toList();

  final highEntropySecrets = generatedSecrets.where((s) => s.entropy >= 70.0);
  print('   Total Generated: ${generatedSecrets.length}');
  print('   Secrets with Entropy >= 70 bits: ${highEntropySecrets.length}');
  for (var s in highEntropySecrets) {
    print('   - Len: ${s.length} | Entropy: ${s.entropy.toStringAsFixed(1)} bits | Strength: ${s.strength.name}');
  }

  print('\n>>> Experiment 1 Dart SDK Demo completed successfully! <<<');
}
