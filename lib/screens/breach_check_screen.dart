import 'package:flutter/material.dart';
import '../services/breach_api_service.dart';
import '../utils/responsive_container.dart';
import '../widgets/gradient_button.dart';

/// Experiment 9: Fetch data from a REST API and display in UI
class BreachCheckScreen extends StatefulWidget {
  final String? initialPassword;

  const BreachCheckScreen({super.key, this.initialPassword});

  @override
  State<BreachCheckScreen> createState() => _BreachCheckScreenState();
}

class _BreachCheckScreenState extends State<BreachCheckScreen> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  BreachCheckResult? _result;
  String? _errorMessage;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPassword ?? '');
    if (_controller.text.isNotEmpty) {
      _performAudit();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performAudit() async {
    final password = _controller.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a password to audit.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await BreachApiService.checkPasswordBreach(password);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'API Fetch Failed: Unable to connect to HaveIBeenPwned REST API.\n'
            'Please check your internet connection and try again.\n(Details: $e)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Breach Auditor'),
        elevation: 0,
      ),
      body: ResponsiveContentContainer(
        maxWidth: 800,
        child: ListView(
          children: [
            // Header Explanation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HaveIBeenPwned k-Anonymity REST API',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Queries over 850 million breached passwords in historical data leaks. '
                          'Your actual password is never sent across the network — only the first 5 SHA-1 hash characters are transmitted (k-Anonymity).',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Password Input Box
            TextField(
              controller: _controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Enter Password to Check',
                hintText: 'e.g. SecretPassword123!',
                prefixIcon: const Icon(Icons.vpn_key_rounded),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Audit Action CTA
            GradientButton(
              text: 'Check Breach Database',
              icon: Icons.search_rounded,
              isLoading: _isLoading,
              onPressed: _performAudit,
            ),
            const SizedBox(height: 24),

            // Experiment 9b: Meaningful Data Display in UI
            if (_isLoading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 14),
                      Text(
                        'Fetching security breach telemetry from REST API...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_errorMessage != null) ...[
              // Error State Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Network / API Error',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_errorMessage!, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry Query'),
                      onPressed: _performAudit,
                    ),
                  ],
                ),
              ),
            ] else if (_result != null) ...[
              _buildResultCard(_result!, isDark, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BreachCheckResult result, bool isDark, ThemeData theme) {
    final isBreached = result.isBreached;
    final statusColor = isBreached ? const Color(0xFFEF4444) : const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181D2B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBreached ? Icons.gpp_bad_rounded : Icons.verified_user_rounded,
                  color: statusColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBreached ? 'PASSWORD COMPROMISED!' : 'GOOD NEWS — NOT BREACHED!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBreached
                          ? 'This password was seen in known data breaches.'
                          : 'Zero instances of this password found in public leak records.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),

          // Details Grid
          _buildInfoRow('Breach Count:', isBreached ? '${result.breachCount} times' : '0 times',
              valueColor: isBreached ? Colors.redAccent : Colors.green),
          const SizedBox(height: 8),
          _buildInfoRow('SHA-1 Prefix Sent (k-Anonymity):', result.prefix),
          const SizedBox(height: 8),
          _buildInfoRow('Full SHA-1 (Client-side Only):', result.sha1Hash),
          const SizedBox(height: 8),
          _buildInfoRow('API Response Latency:', '${result.latency.inMilliseconds} ms'),
          const SizedBox(height: 16),

          // Security Recommendation Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded, size: 18, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isBreached
                        ? 'Recommendation: Never use this password! Generate a high-entropy 16+ character password with symbols and uppercase letters.'
                        : 'Recommendation: While clean in known breaches, ensure you use unique passwords for each service with Multi-Factor Authentication (2FA).',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
