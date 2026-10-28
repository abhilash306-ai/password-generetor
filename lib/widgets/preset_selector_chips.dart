import 'package:flutter/material.dart';
import '../core/dart_basics.dart';

/// Custom Chips widget for preset selection
class PresetSelectorChips extends StatelessWidget {
  final PasswordPreset activePreset;
  final ValueChanged<PasswordPreset> onSelected;

  const PresetSelectorChips({
    super.key,
    required this.activePreset,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: PasswordPreset.values.map((preset) {
          final isSelected = preset == activePreset;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              label: Text(preset.label),
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              selectedColor: theme.colorScheme.primary,
              backgroundColor: isDark ? const Color(0xFF1E222D) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : (isDark ? Colors.white12 : Colors.black12),
                ),
              ),
              onSelected: (_) => onSelected(preset),
            ),
          );
        }).toList(),
      ),
    );
  }
}
