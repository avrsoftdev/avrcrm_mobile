import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../dashboard/home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (_idCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      setState(() {
        _error = 'Please enter User ID and Password';
        _loading = false;
      });
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                onPressed: () => context.read<ThemeProvider>().toggle(),
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.primary.withOpacity(0.25)),
                      ),
                      child: const Icon(Icons.shield_rounded, color: AppTheme.primary, size: 32),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'AVRCRM',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to your CRM workspace',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome back', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            'Enter your credentials to continue',
                            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.destructive.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.destructive.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: AppTheme.destructive, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(_error!, style: const TextStyle(color: AppTheme.destructive, fontSize: 12))),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          Text('User ID / Email', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodySmall?.color)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _idCtrl,
                            decoration: const InputDecoration(
                              hintText: 'admin@avrcrm.in',
                              prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodySmall?.color)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            onSubmitted: (_) => _login(),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,
                              child: _loading
                                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                                  : const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Demo: Enter any email & password',
                              style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
