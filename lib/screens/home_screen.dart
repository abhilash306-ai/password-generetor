import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/dart_basics.dart';
import '../providers/password_provider.dart';
import '../routes/app_routes.dart';
import '../utils/responsive_layout.dart';
import '../widgets/animated_password_card.dart';
import '../widgets/custom_option_tile.dart';
import '../widgets/gradient_button.dart';
import '../widgets/password_strength_meter.dart';
import '../widgets/preset_selector_chips.dart';
import '../widgets/responsive_container.dart';
import 'save_password_sheet.dart';

/// Experiment 2, 3, 5, 8: Main Password Generator Screen
/// Features:
/// - Experiment 2: Widgets & Layouts (Text, Row, Column, Stack)
/// - Experiment 3: Responsive Layouts (Mobile vs Tablet/Desktop)
/// - Experiment 5: Stateful vs Stateless, setState & Provider
/// - Experiment 8: Animations (Scale, Slide, Fade, Rotation)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Experiment 8a: Flutter Animation Controller
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    // Experiment 8a: AnimationController initialization
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Experiment 8b: FadeTransition Tween
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    // Experiment 8b: SlideTransition Tween
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    // Experiment 8b: Scale / Bounce Animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 50),
    ]).animate(_animController);

    // Experiment 8b: Rotation Animation for generator dice/refresh
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _triggerRegenerateWithAnimation() {
    final passwordProvider = Provider.of<PasswordProvider>(context, listen: false);
    _animController.reset();
    passwordProvider.regenerate();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ResponsiveBreakpoints.isDesktop(context);
    final passwordProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.shield_rounded, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 10),
            const Text('PassShield'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.school_outlined),
            tooltip: '10 Experiments Syllabus Mapping',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.labOverview),
          ),
          IconButton(
            icon: const Icon(Icons.security_rounded),
            tooltip: 'Check Breaches (REST API)',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.breachCheck,
              arguments: passwordProvider.currentPassword,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: ResponsiveContentContainer(
        maxWidth: 1100,
        child: ResponsiveLayout(
          // Mobile View: Single column scrollable
          mobile: _buildMobileLayout(passwordProvider),
          // Tablet & Desktop View: 2-column split layout
          tablet: _buildSplitLayout(passwordProvider, isDesktop: false),
          desktop: _buildSplitLayout(passwordProvider, isDesktop: true),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _triggerRegenerateWithAnimation,
        icon: RotationTransition(
          turns: _rotateAnimation,
          child: const Icon(Icons.sync_rounded),
        ),
        label: const Text('Generate'),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withBlue(220),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.shield_rounded, color: Colors.white, size: 38),
                SizedBox(height: 8),
                Text(
                  'PassShield Security',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'CS506PC – UI Design (Flutter Lab)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.vpn_key_rounded),
            title: const Text('Password Generator'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.lock_rounded),
            title: const Text('Password Vault'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.vault);
            },
          ),
          ListTile(
            leading: const Icon(Icons.security_rounded),
            title: const Text('Breach Auditor (REST API)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.breachCheck);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school_rounded, color: Colors.blueAccent),
            title: const Text('10 Lab Experiments Mapping'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.labOverview);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings & Themes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(PasswordProvider provider) {
    return ListView(
      children: [
        // Presets
        PresetSelectorChips(
          activePreset: provider.activePreset,
          onSelected: (p) => provider.applyPreset(p),
        ),
        const SizedBox(height: 16),

        // Experiment 8: Fade & Slide animated card
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: AnimatedPasswordCard(
              password: provider.currentPassword,
              entropy: provider.currentEntropy,
              strength: provider.currentStrength,
              onRegenerate: _triggerRegenerateWithAnimation,
              onSave: () => SavePasswordSheet.show(
                context,
                initialPassword: provider.currentPassword,
                initialEntropy: provider.currentEntropy,
                initialStrength: provider.currentStrength,
              ),
              onAudit: () => Navigator.pushNamed(
                context,
                AppRoutes.breachCheck,
                arguments: provider.currentPassword,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Strength meter
        PasswordStrengthMeter(
          strength: provider.currentStrength,
          entropy: provider.currentEntropy,
        ),
        const SizedBox(height: 20),

        // Length slider & controls
        _buildLengthSliderCard(provider),
        const SizedBox(height: 14),

        // Options switches
        _buildOptionsList(provider),
        const SizedBox(height: 24),

        // Generate Action Button
        ScaleTransition(
          scale: _scaleAnimation,
          child: GradientButton(
            text: 'Generate New Password',
            icon: Icons.refresh_rounded,
            onPressed: _triggerRegenerateWithAnimation,
          ),
        ),
        const SizedBox(height: 80), // Padding for FAB
      ],
    );
  }

  Widget _buildSplitLayout(PasswordProvider provider, {required bool isDesktop}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Password Display & Strength
        Expanded(
          flex: isDesktop ? 5 : 6,
          child: ListView(
            padding: const EdgeInsets.only(right: 16),
            children: [
              PresetSelectorChips(
                activePreset: provider.activePreset,
                onSelected: (p) => provider.applyPreset(p),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedPasswordCard(
                    password: provider.currentPassword,
                    entropy: provider.currentEntropy,
                    strength: provider.currentStrength,
                    onRegenerate: _triggerRegenerateWithAnimation,
                    onSave: () => SavePasswordSheet.show(
                      context,
                      initialPassword: provider.currentPassword,
                      initialEntropy: provider.currentEntropy,
                      initialStrength: provider.currentStrength,
                    ),
                    onAudit: () => Navigator.pushNamed(
                      context,
                      AppRoutes.breachCheck,
                      arguments: provider.currentPassword,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PasswordStrengthMeter(
                strength: provider.currentStrength,
                entropy: provider.currentEntropy,
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: GradientButton(
                  text: 'Generate New Password',
                  icon: Icons.refresh_rounded,
                  onPressed: _triggerRegenerateWithAnimation,
                ),
              ),
            ],
          ),
        ),

        // Right Column: Configuration & Controls
        Expanded(
          flex: isDesktop ? 6 : 6,
          child: ListView(
            padding: const EdgeInsets.only(left: 16),
            children: [
              _buildLengthSliderCard(provider),
              const SizedBox(height: 14),
              _buildOptionsList(provider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLengthSliderCard(PasswordProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E222D) : Colors.white,
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
              Text(
                'Password Length',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${provider.length} chars',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: theme.colorScheme.primary,
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withOpacity(0.12),
              trackHeight: 4,
            ),
            child: Slider(
              value: provider.length.toDouble(),
              min: 4,
              max: 64,
              divisions: 60,
              onChanged: (val) {
                provider.setLength(val.round());
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('4 (Short)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
              Text('16 (Recommended)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
              Text('64 (Max)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(PasswordProvider provider) {
    return Column(
      children: [
        CustomOptionTile(
          title: 'Uppercase Letters (A-Z)',
          subtitle: 'Include capitalized letters',
          icon: Icons.text_fields_rounded,
          value: provider.includeUppercase,
          onChanged: (val) => provider.toggleUppercase(val),
        ),
        CustomOptionTile(
          title: 'Lowercase Letters (a-z)',
          subtitle: 'Include small letters',
          icon: Icons.sort_by_alpha_rounded,
          value: provider.includeLowercase,
          onChanged: (val) => provider.toggleLowercase(val),
        ),
        CustomOptionTile(
          title: 'Numbers (0-9)',
          subtitle: 'Include numeric digits',
          icon: Icons.pin_rounded,
          value: provider.includeNumbers,
          onChanged: (val) => provider.toggleNumbers(val),
        ),
        CustomOptionTile(
          title: 'Special Symbols (!@#\$%^&*)',
          subtitle: 'Include cryptographic symbols',
          icon: Icons.emergency_rounded,
          value: provider.includeSymbols,
          onChanged: (val) => provider.toggleSymbols(val),
        ),
        CustomOptionTile(
          title: 'Exclude Ambiguous (l, 1, I, O, 0)',
          subtitle: 'Avoid easily confused characters',
          icon: Icons.visibility_off_rounded,
          value: provider.excludeAmbiguous,
          onChanged: (val) => provider.toggleAmbiguous(val),
        ),
      ],
    );
  }
}
