import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/dart_basics.dart';

/// Experiment 2: Flutter Widgets & Layouts (Text, Image/Icon, Container, Row, Column, Stack)
/// Demonstrates Stack with overlay badges, Row for action buttons, Column for vertical flow.
class AnimatedPasswordCard extends StatelessWidget {
  final String password;
  final double entropy;
  final PasswordStrength strength;
  final VoidCallback onRegenerate;
  final VoidCallback onSave;
  final VoidCallback onAudit;

  const AnimatedPasswordCard({
    super.key,
    required this.password,
    required this.entropy,
    required this.strength,
    required this.onRegenerate,
    required this.onSave,
    required this.onAudit,
  });

  Color _getStrengthColor() {
    switch (strength) {
      case PasswordStrength.veryWeak:
      case PasswordStrength.weak:
        return const Color(0xFFEF4444); // Red
      case PasswordStrength.fair:
        return const Color(0xFFF59E0B); // Amber
      case PasswordStrength.good:
        return const Color(0xFF10B981); // Emerald
      case PasswordStrength.strong:
        return const Color(0xFF06B6D4); // Cyan
      case PasswordStrength.militaryGrade:
        return const Color(0xFF8B5CF6); // Violet
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strengthColor = _getStrengthColor();

    // Experiment 2b: Stack layout to superimpose strength badge and copy trigger on Container
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Card Container (Experiment 2a)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E2230), const Color(0xFF131722)]
                  : [Colors.white, const Color(0xFFF8FAFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: strengthColor.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: strengthColor.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // Experiment 2b: Column for structured vertical placement
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // Experiment 2b: Row for security shield icon + title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: strengthColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.shield_rounded, color: strengthColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'GENERATED CIPHERTEXT',
                    style: theme.textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: strengthColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Password Display Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0E131F) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                child: SelectableText(
                  password.isEmpty ? '••••••••••••••••' : password,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: password.isEmpty
                        ? Colors.grey
                        : (isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Experiment 2b: Row for quick action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: password));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password copied to clipboard!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.refresh_rounded,
                    label: 'Generate',
                    color: const Color(0xFF10B981),
                    onTap: onRegenerate,
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.bookmark_add_rounded,
                    label: 'Save',
                    color: const Color(0xFFF59E0B),
                    onTap: onSave,
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.security_rounded,
                    label: 'Audit API',
                    color: const Color(0xFF8B5CF6),
                    onTap: onAudit,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Experiment 2b: Stack positioned badge at top right
        Positioned(
          top: -10,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: strengthColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: strengthColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '${strength.displayName.toUpperCase()} (${entropy.toBitString()})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
