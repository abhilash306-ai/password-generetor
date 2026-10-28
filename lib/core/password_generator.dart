import 'dart:math';
import 'dart_basics.dart';

/// Password Generator Options
class GeneratorOptions {
  final int length;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSymbols;
  final bool excludeAmbiguous;
  final String? customExcludeChars;

  const GeneratorOptions({
    this.length = 16,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
    this.excludeAmbiguous = false,
    this.customExcludeChars,
  });

  GeneratorOptions copyWith({
    int? length,
    bool? includeUppercase,
    bool? includeLowercase,
    bool? includeNumbers,
    bool? includeSymbols,
    bool? excludeAmbiguous,
    String? customExcludeChars,
  }) {
    return GeneratorOptions(
      length: length ?? this.length,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSymbols: includeSymbols ?? this.includeSymbols,
      excludeAmbiguous: excludeAmbiguous ?? this.excludeAmbiguous,
      customExcludeChars: customExcludeChars ?? this.customExcludeChars,
    );
  }
}

/// Generation Result containing value, entropy, and strength metadata
class GenerationResult {
  final String password;
  final double entropy;
  final PasswordStrength strength;
  final int poolSize;
  final DateTime generatedAt;

  const GenerationResult({
    required this.password,
    required this.entropy,
    required this.strength,
    required this.poolSize,
    required this.generatedAt,
  });
}

/// Pure Dart Password Generation Engine
class PasswordGenerator {
  static const String upperChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String lowerChars = 'abcdefghijklmnopqrstuvwxyz';
  static const String numberChars = '0123456789';
  static const String symbolChars = '!@#\$%^&*()-_=+[]{}|;:,.<>?';
  static const String ambiguousChars = 'l1IO0o';

  /// Generates a cryptographically strong random password
  static GenerationResult generate(GeneratorOptions options) {
    var upper = upperChars;
    var lower = lowerChars;
    var numbers = numberChars;
    var symbols = symbolChars;

    if (options.excludeAmbiguous) {
      for (final char in ambiguousChars.split('')) {
        upper = upper.replaceAll(char, '');
        lower = lower.replaceAll(char, '');
        numbers = numbers.replaceAll(char, '');
      }
    }

    if (options.customExcludeChars != null && options.customExcludeChars!.isNotEmpty) {
      for (final char in options.customExcludeChars!.split('')) {
        upper = upper.replaceAll(char, '');
        lower = lower.replaceAll(char, '');
        numbers = numbers.replaceAll(char, '');
        symbols = symbols.replaceAll(char, '');
      }
    }

    final poolBuilder = StringBuffer();
    final guaranteedChars = <String>[];
    final random = Random.secure();

    if (options.includeUppercase && upper.isNotEmpty) {
      poolBuilder.write(upper);
      guaranteedChars.add(upper[random.nextInt(upper.length)]);
    }
    if (options.includeLowercase && lower.isNotEmpty) {
      poolBuilder.write(lower);
      guaranteedChars.add(lower[random.nextInt(lower.length)]);
    }
    if (options.includeNumbers && numbers.isNotEmpty) {
      poolBuilder.write(numbers);
      guaranteedChars.add(numbers[random.nextInt(numbers.length)]);
    }
    if (options.includeSymbols && symbols.isNotEmpty) {
      poolBuilder.write(symbols);
      guaranteedChars.add(symbols[random.nextInt(symbols.length)]);
    }

    final pool = poolBuilder.toString();
    if (pool.isEmpty) {
      throw ArgumentError('At least one character set must be selected');
    }

    final passwordChars = <String>[...guaranteedChars];
    final remainingLength = max(0, options.length - guaranteedChars.length);

    for (int i = 0; i < remainingLength; i++) {
      passwordChars.add(pool[random.nextInt(pool.length)]);
    }

    // Cryptographic shuffle
    for (int i = passwordChars.length - 1; i > 0; i--) {
      final n = random.nextInt(i + 1);
      final temp = passwordChars[i];
      passwordChars[i] = passwordChars[n];
      passwordChars[n] = temp;
    }

    final password = passwordChars.join();
    final entropy = calculateEntropy(password, pool.length);
    final strength = evaluateStrength(entropy);

    return GenerationResult(
      password: password,
      entropy: entropy,
      strength: strength,
      poolSize: pool.length,
      generatedAt: DateTime.now(),
    );
  }

  /// Shannon Entropy: E = L * log2(R)
  static double calculateEntropy(String password, int poolSize) {
    if (password.isEmpty || poolSize <= 0) return 0.0;
    return password.length * (log(poolSize) / ln2);
  }

  /// Maps entropy in bits to user-friendly strength
  static PasswordStrength evaluateStrength(double entropy) {
    if (entropy < 28) return PasswordStrength.veryWeak;
    if (entropy < 45) return PasswordStrength.weak;
    if (entropy < 65) return PasswordStrength.fair;
    if (entropy < 85) return PasswordStrength.good;
    if (entropy < 115) return PasswordStrength.strong;
    return PasswordStrength.militaryGrade;
  }
}
