import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final company = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;
  String? error;

  @override
  void dispose() {
    name.dispose();
    company.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future<void> register() async {
    FocusScope.of(context).unfocus();

    if (name.text.trim().isEmpty ||
        company.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.isEmpty) {
      setState(() => error = 'Please complete all required fields.');
      return;
    }

    if (password.text.length < 8) {
      setState(() => error = 'Password must contain at least 8 characters.');
      return;
    }

    if (password.text != confirmPassword.text) {
      setState(() => error = 'Passwords do not match.');
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await context.read<AuthService>().register(
            email: email.text.trim(),
            password: password.text,
            name: name.text.trim(),
            companyName: company.text.trim(),
          );

      if (!mounted) return;

      if (response.session == null) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Verify your email'),
            content: Text(
              'Account created for ${email.text.trim()}. Check your email and verify the address before signing in.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        if (mounted) Navigator.pop(context);
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => error = _cleanError(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _cleanError(Object e) {
    final text = e.toString().toLowerCase();
    if (text.contains('user already registered')) {
      return 'An account already exists with this email.';
    }
    if (text.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    if (text.contains('password')) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    return e.toString().replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create AVRCRM Account')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.10),
              theme.scaffoldBackgroundColor,
              colors.secondary.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/avrcrm_logo.png',
                            height: 82,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.business_center_rounded,
                              size: 64,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Create your workspace',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your first account becomes the administrator of the company workspace.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _field(
                          controller: name,
                          label: 'Your Name',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),
                        _field(
                          controller: company,
                          label: 'Company Name',
                          icon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 14),
                        _field(
                          controller: email,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: password,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => obscurePassword = !obscurePassword,
                              ),
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: confirmPassword,
                          obscureText: obscurePassword,
                          onSubmitted: (_) => loading ? null : register(),
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock_reset_outlined),
                          ),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.error.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              error!,
                              style: TextStyle(color: colors.error),
                            ),
                          ),
                        ],
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: loading ? null : register,
                            icon: loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.person_add_alt_1),
                            label: Text(
                              loading ? 'Creating...' : 'Create Account',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
