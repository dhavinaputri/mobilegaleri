import 'package:flutter/material.dart';
import '../../routes.dart';
import '../login_guest_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  InputDecoration _deco(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide(color: scheme.outline)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide(color: scheme.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F5FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFFEFF6FF),
                      child: const Icon(Icons.lock_outline, size: 28, color: Color(0xFF1D4ED8)),
                    ),
                    const SizedBox(height: 16),
                    Text('Lupa Password', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                    const SizedBox(height: 6),
                    Text(
                      'Masukkan email Anda. Kami akan mengirimkan link untuk reset password.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Card(
                      elevation: 10,
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _deco(context, 'Email').copyWith(prefixIcon: const Icon(Icons.email_outlined), hintText: 'Masukkan email Anda'),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                                  final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                  return re.hasMatch(v) ? null : 'Format email tidak valid';
                                },
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link reset telah dikirim (dummy)')));
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: const StadiumBorder(),
                                    backgroundColor: const Color(0xFF1D4ED8),
                                  ),
                                  icon: const Icon(Icons.send_rounded),
                                  label: const Text('Kirim Link Reset'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginGuestPage())),
                      child: const Text('Kembali ke login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
