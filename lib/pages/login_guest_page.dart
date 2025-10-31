import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginGuestPage extends StatefulWidget {
  const LoginGuestPage({super.key});

  @override
  State<LoginGuestPage> createState() => _LoginGuestPageState();
}

class _LoginGuestPageState extends State<LoginGuestPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@test.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _remember = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      
      if (!mounted) return;
      
      // Navigasi ke halaman home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  Future<void> _loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    InputDecoration _fieldDecoration(String hint) => InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: scheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: LayoutBuilder(
        builder: (_, constraints) {
          final isWide = constraints.maxWidth > 700;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 560 : 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, size: 40, color: scheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Masuk ke Akun',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                        children: [
                          const TextSpan(text: 'Belum punya akun? '),
                          TextSpan(
                            text: 'Daftar di sini',
                            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      color: scheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email_outlined, color: scheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Email', style: theme.textTheme.labelLarge),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _fieldDecoration('admin@test.com'),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                                  final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                  if (!re.hasMatch(v)) return 'Format email tidak valid';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.lock_outline, color: scheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Password', style: theme.textTheme.labelLarge),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscure,
                                decoration: _fieldDecoration('••••••••').copyWith(
                                  suffixIcon: IconButton(
                                    tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                                    onPressed: () => setState(() => _obscure = !_obscure),
                                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                  ),
                                ),
                                validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _remember,
                                    onChanged: (v) => setState(() => _remember = v ?? false),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('Ingat saya'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _submit,
                                  icon: const Icon(Icons.login),
                                  label: const Text('Masuk'),
                                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                        children: [
                          const TextSpan(text: 'Lupa password? '),
                          TextSpan(
                            text: 'Reset di sini.',
                            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jika mengalami kendala, Anda dapat tetap menghubungi administrator.',
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
