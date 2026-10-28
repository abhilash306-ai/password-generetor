import 'package:flutter/material.dart';
import '../core/dart_basics.dart';

/// Experiment 6a: Custom Reusable Widget for Password Strength & Entropy Meter
class PasswordStrengthMeter extends StatelessWidget {
  final PasswordStrength strength;
  final double entropy;

  const PasswordStrengthMeter({
    super.key,
    required this.strength,
    required this.entropy,
  });

  int get _activeBars {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 1;
      case PasswordStrength.weak:
        return 2;
      case PasswordStrength.fair:
        return 3;
      case PasswordStrength.good:
        return 4;
      case PasswordStrength.strong:
        return 5;
      case PasswordStrength.militaryGrade:
        return 5;
    }
  }

  Color get _color {
    switch (strength) {
      case PasswordStrength.veryWeak:
      case PasswordStrength.weak:
        return const Color(0xFFEF4444);
      case PasswordStrength.fair:
        return const Color(0xFFF59E0B);
      case PasswordStrength.good:
        return const Color(0xFF10B981);
      case PasswordStrength.strong:
        return const Color(0xFF06B6D4);
      case PasswordStrength.militaryGrade:
        return const Color(0xFF8B5CF6);
    }
  }

  String get _crackTimeEstimate {
    if (entropy < 28) return 'Instant crack (< 1 sec)';
    if (entropy < 45) return '~ Few minutes on standard GPU';
    if (entropy < 65) return '~ 3 to 12 months (Brute-force)';
    if (entropy < 85) return '~ 500+ years';
    if (entropy < 115) return '~ 100,000+ years';
    return 'Centuries / Uncrackable quantum threshold';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF242C3F) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Strength Analysis',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  strength.displayName,
                  style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 5-Segment Strength Bar
          Row(
            children: List.generate(5, (index) {
              final isFilled = index < _activeBars;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: index == 4 ? 0 : 6),
                  height: 6,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? _color
                        : (isDark ? Colors.white10 : Colors.black12),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: isDark ? Colors.white60 : Colors.black54),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _crackTimeEstimate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entropy.toBitString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
