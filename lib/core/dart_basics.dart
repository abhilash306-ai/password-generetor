/// Experiment 1: Dart Language Basics Reference & Core Models
/// Contains foundational types, enums, and extension methods.

/// Password Strength categories evaluated by entropy
enum PasswordStrength {
  veryWeak,
  weak,
  fair,
  good,
  strong,
  militaryGrade;

  String get displayName {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 'Very Weak';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.militaryGrade:
        return 'Military Grade';
    }
  }

  double get scoreMultiplier {
    switch (this) {
      case PasswordStrength.veryWeak:
        return 0.15;
      case PasswordStrength.weak:
        return 0.35;
      case PasswordStrength.fair:
        return 0.55;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 0.90;
      case PasswordStrength.militaryGrade:
        return 1.0;
    }
  }
}

/// Category presets for password generation forms
enum PasswordPreset {
  standard('Standard (16 chars)', 16, true, true, true, true),
  pin('PIN (4 digits)', 4, false, false, true, false),
  alphanumeric('Alphanumeric (14 chars)', 14, true, true, true, false),
  secureKey('Ultra Secure (24 chars)', 24, true, true, true, true),
  maximumSecurity('Max Entropy (32 chars)', 32, true, true, true, true);

  final String label;
  final int defaultLength;
  final bool upper;
  final bool lower;
  final bool numbers;
  final bool symbols;

  const PasswordPreset(
    this.label,
    this.defaultLength,
    this.upper,
    this.lower,
    this.numbers,
    this.symbols,
  );
}

/// Vault item categorization
enum VaultCategory {
  social('Social Media', 'people'),
  work('Work & Office', 'work'),
  banking('Financial / Banking', 'account_balance'),
  entertainment('Entertainment & Gaming', 'sports_esports'),
  personal('Personal & Other', 'lock');

  final String label;
  final String iconKey;
  const VaultCategory(this.label, this.iconKey);
}

/// Extension demonstrating Dart 2.7+ extension methods
extension EntropyFormatter on double {
  String toBitString() => '${toStringAsFixed(1)} bits';
}
