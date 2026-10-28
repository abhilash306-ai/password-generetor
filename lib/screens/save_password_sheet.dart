import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/dart_basics.dart';
import '../core/password_generator.dart';
import '../core/password_model.dart';
import '../providers/vault_provider.dart';
import '../widgets/gradient_button.dart';

/// Experiment 7: Forms, Diverse Input Fields, Validation, and Error Handling
class SavePasswordSheet extends StatefulWidget {
  final String initialPassword;
  final double? initialEntropy;
  final PasswordStrength? initialStrength;

  const SavePasswordSheet({
    super.key,
    required this.initialPassword,
    this.initialEntropy,
    this.initialStrength,
  });

  static Future<void> show(
    BuildContext context, {
    required String initialPassword,
    double? initialEntropy,
    PasswordStrength? initialStrength,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SavePasswordSheet(
          initialPassword: initialPassword,
          initialEntropy: initialEntropy,
          initialStrength: initialStrength,
        ),
      ),
    );
  }

  @override
  State<SavePasswordSheet> createState() => _SavePasswordSheetState();
}

class _SavePasswordSheetState extends State<SavePasswordSheet> {
  // Experiment 7b: Form Key for validation and error state management
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _notesController;

  VaultCategory _selectedCategory = VaultCategory.work;
  bool _obscurePassword = true;
  bool _isHighPriority = false;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController(text: widget.initialPassword);
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() => _autoValidate = true);

    // Experiment 7b: Form Validation Execution
    if (_formKey.currentState!.validate()) {
      final entropy = widget.initialEntropy ??
          PasswordGenerator.calculateEntropy(
            _passwordController.text,
            94,
          );
      final strength = widget.initialStrength ??
          PasswordGenerator.evaluateStrength(entropy);

      final newItem = VaultItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        category: _selectedCategory,
        createdAt: DateTime.now(),
        entropy: entropy,
        strength: strength,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // Save to Provider
      Provider.of<VaultProvider>(context, listen: false).addItem(newItem);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Saved "${newItem.title}" to secure vault!'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Error Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please correct the form validation errors highlighted in red.'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode:
              _autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bottom sheet handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.bookmark_add_rounded, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Save to Secure Vault',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Experiment 7a: Input Field 1 - Title / Service Name with Validator
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Account / Service Name *',
                  hintText: 'e.g. GitHub, AWS Console, Work Email',
                  prefixIcon: Icon(Icons.business_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Service name is required';
                  }
                  if (val.trim().length < 2) {
                    return 'Must be at least 2 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Experiment 7a: Input Field 2 - Username / Email with Regex Validation
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username or Email *',
                  hintText: 'e.g. user@organization.com',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Username or email cannot be empty';
                  }
                  if (val.contains('@') &&
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Experiment 7a: Input Field 3 - Password with Obscure Toggle & Length Validator
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password field cannot be empty';
                  }
                  if (val.length < 6) {
                    return 'Password must have at least 6 characters for safety';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Experiment 7a: Input Field 4 - DropdownButtonFormField for Category
              DropdownButtonFormField<VaultCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Vault Category',
                  prefixIcon: Icon(Icons.folder_open_rounded),
                ),
                items: VaultCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.label),
                  );
                }).toList(),
                onChanged: (cat) {
                  if (cat != null) {
                    setState(() => _selectedCategory = cat);
                  }
                },
              ),
              const SizedBox(height: 14),

              // Experiment 7a: Input Field 5 - SwitchListTile for Priority Tag
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Require Master Pin to View'),
                subtitle: const Text('Enables sensitive biometric authentication tag'),
                value: _isHighPriority,
                onChanged: (val) => setState(() => _isHighPriority = val),
              ),
              const SizedBox(height: 8),

              // Experiment 7a: Input Field 6 - Multiline TextFormField for Notes
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Optional Security Notes',
                  hintText: 'e.g., 2FA recovery backup codes, security questions',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 24),

              // Form Submission Button
              GradientButton(
                text: 'Save to Vault',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _submitForm,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
