import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Data class representing breach status from REST API
class BreachCheckResult {
  final bool isBreached;
  final int breachCount;
  final String sha1Hash;
  final String prefix;
  final Duration latency;
  final DateTime checkedAt;

  const BreachCheckResult({
    required this.isBreached,
    required this.breachCount,
    required this.sha1Hash,
    required this.prefix,
    required this.latency,
    required this.checkedAt,
  });
}

/// Experiment 9: REST API Integration Service
/// Connects to HaveIBeenPwned Passwords Range API using k-Anonymity model
class BreachApiService {
  static const String baseUrl = 'https://api.pwnedpasswords.com/range';

  /// Performs SHA-1 hash and queries the HaveIBeenPwned Range REST API
  static Future<BreachCheckResult> checkPasswordBreach(String password) async {
    final stopwatch = Stopwatch()..start();

    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    // 1. Calculate SHA-1 hash locally in uppercase
    final bytes = utf8.encode(password);
    final digest = sha1.convert(bytes);
    final fullHash = digest.toString().toUpperCase();

    // 2. K-Anonymity: Split into 5-char prefix and 35-char suffix
    final prefix = fullHash.substring(0, 5);
    final suffix = fullHash.substring(5);

    final url = Uri.parse('$baseUrl/$prefix');

    try {
      // 3. REST API GET Request
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'PassShield-Flutter-Lab-CS506PC',
          'Add-Padding': 'true', // Privacy enhancement
        },
      ).timeout(const Duration(seconds: 10));

      stopwatch.stop();

      if (response.statusCode == 200) {
        // 4. Parse the newline-delimited hash suffix list
        final lines = const LineSplitter().convert(response.body);
        int count = 0;

        for (final line in lines) {
          final parts = line.split(':');
          if (parts.length == 2) {
            final hashSuffix = parts[0].trim();
            if (hashSuffix == suffix) {
              count = int.tryParse(parts[1].trim()) ?? 0;
              break;
            }
          }
        }

        return BreachCheckResult(
          isBreached: count > 0,
          breachCount: count,
          sha1Hash: fullHash,
          prefix: prefix,
          latency: stopwatch.elapsed,
          checkedAt: DateTime.now(),
        );
      } else {
        throw Exception('Server responded with HTTP ${response.statusCode}');
      }
    } catch (e) {
      stopwatch.stop();
      rethrow;
    }
  }
}
