import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/dart_basics.dart';
import 'package:password_generator/core/password_generator.dart';

/// Experiment 10a: Unit Tests for Business Logic & Cryptographic Engine
void main() {
  group('Experiment 1 & 10a: Password Generator Unit Tests', () {
    test('Should generate password with specified length', () {
      const length = 20;
      final result = PasswordGenerator.generate(
        const GeneratorOptions(length: length),
      );

      expect(result.password.length, equals(length));
      expect(result.entropy, greaterThan(80.0));
    });

    test('Should exclude ambiguous characters when enabled', () {
      const options = GeneratorOptions(
        length: 50,
        excludeAmbiguous: true,
      );

      final result = PasswordGenerator.generate(options);

      // Verify no ambiguous characters (l, 1, I, O, 0, o)
      for (final char in 'l1IO0o'.split('')) {
        expect(result.password.contains(char), isFalse,
            reason: 'Password should not contain ambiguous char $char');
      }
    });

    test('Should calculate Shannon entropy correctly', () {
      // 16 chars with 94 pool size should yield ~104.87 bits
      final entropy = PasswordGenerator.calculateEntropy('TestPassword123!', 94);
      expect(entropy, closeTo(104.87, 0.5));
    });

    test('Should correctly evaluate password strength categories', () {
      expect(PasswordGenerator.evaluateStrength(20.0), equals(PasswordStrength.veryWeak));
      expect(PasswordGenerator.evaluateStrength(35.0), equals(PasswordStrength.weak));
      expect(PasswordGenerator.evaluateStrength(55.0), equals(PasswordStrength.fair));
      expect(PasswordGenerator.evaluateStrength(75.0), equals(PasswordStrength.good));
      expect(PasswordGenerator.evaluateStrength(95.0), equals(PasswordStrength.strong));
      expect(PasswordGenerator.evaluateStrength(120.0), equals(PasswordStrength.militaryGrade));
    });

    test('K-Anonymity SHA-1 hash split verification', () {
      const testInput = 'password';
      final digest = sha1.convert(utf8.encode(testInput)).toString().toUpperCase();

      // Known SHA-1 for 'password' is 5BAA61E4C9B93F3F0682250B6CF8331B7EE68FD8
      expect(digest, equals('5BAA61E4C9B93F3F0682250B6CF8331B7EE68FD8'));

      final prefix = digest.substring(0, 5);
      final suffix = digest.substring(5);

      expect(prefix, equals('5BAA6'));
      expect(suffix, equals('1E4C9B93F3F0682250B6CF8331B7EE68FD8'));
      expect(prefix.length, equals(5));
      expect(suffix.length, equals(35));
    });
  });
}
